class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://github.com/cloudposse/atmos/archive/v1.45.3.tar.gz"
  sha256 "b70dfd5d4f74f87b6a1ef8c2f5ddc780cecf6b1c22d357f8b0005df2a7dbe953"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afac3ea53a31ba6afff1fd45525d2f4221286bd9aad04b5671c9c685e9ff150c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8022848cf63dece18c0675000410da480fa3b82711e0dbbbbf047e2b92184c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5dad549510c069bbda79ed7989c81ec8ea65de5b6c8dbdd14e4a625d6cfc967"
    sha256 cellar: :any_skip_relocation, ventura:        "d490c0de8224d176dd6bf0030a6deac378940b1d1388197bef960a665c0404e2"
    sha256 cellar: :any_skip_relocation, monterey:       "7fccbdd282eca8f4aa98a11f6f68d2f31843c109815a88d17b09823f37285416"
    sha256 cellar: :any_skip_relocation, big_sur:        "02ab8e619727a6c6c9af9efcb4c97831653304adf91124f2551c48b9502c902a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75e29a211f590287bc3a2781d36d44010f0f46113259c6bd94fe2c1d9217d196"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/cloudposse/atmos/cmd.Version=#{version}")

    generate_completions_from_executable(bin/"atmos", "completion")
  end

  test do
    # create basic atmos.yaml
    (testpath/"atmos.yaml").write <<~EOT
      components:
        terraform:
          base_path: "./components/terraform"
          apply_auto_approve: false
          deploy_run_init: true
          auto_generate_backend_file: false
        helmfile:
          base_path: "./components/helmfile"
          kubeconfig_path: "/dev/shm"
          helm_aws_profile_pattern: "{namespace}-{tenant}-gbl-{stage}-helm"
          cluster_name_pattern: "{namespace}-{tenant}-{environment}-{stage}-eks-cluster"
      stacks:
        base_path: "./stacks"
        included_paths:
          - "**/*"
        excluded_paths:
          - "globals/**/*"
          - "catalog/**/*"
          - "**/*globals*"
        name_pattern: "{tenant}-{environment}-{stage}"
      logs:
        verbose: false
        colors: true
    EOT

    # create scaffold
    mkdir_p testpath/"stacks"
    mkdir_p testpath/"components/terraform/top-level-component1"
    (testpath/"stacks/tenant1-ue2-dev.yaml").write <<~EOT
      terraform:
        backend_type: s3 # s3, remote, vault, static, etc.
        backend:
          s3:
            encrypt: true
            bucket: "eg-ue2-root-tfstate"
            key: "terraform.tfstate"
            dynamodb_table: "eg-ue2-root-tfstate-lock"
            acl: "bucket-owner-full-control"
            region: "us-east-2"
            role_arn: null
          remote:
          vault:

      vars:
        tenant: tenant1
        region: us-east-2
        environment: ue2
        stage: dev

      components:
        terraform:
          top-level-component1: {}
    EOT

    # create expected file
    (testpath/"backend.tf.json").write <<~EOT
      {
        "terraform": {
          "backend": {
            "s3": {
              "workspace_key_prefix": "top-level-component1",
              "acl": "bucket-owner-full-control",
              "bucket": "eg-ue2-root-tfstate",
              "dynamodb_table": "eg-ue2-root-tfstate-lock",
              "encrypt": true,
              "key": "terraform.tfstate",
              "region": "us-east-2",
              "role_arn": null
            }
          }
        }
      }
    EOT

    system bin/"atmos", "terraform", "generate", "backend", "top-level-component1", "--stack", "tenant1-ue2-dev"
    actual_json = JSON.parse(File.read(testpath/"components/terraform/top-level-component1/backend.tf.json"))
    expected_json = JSON.parse(File.read(testpath/"backend.tf.json"))
    assert_equal expected_json["terraform"].to_set, actual_json["terraform"].to_set
  end
end

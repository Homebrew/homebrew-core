class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://github.com/cloudposse/atmos/archive/v1.12.1.tar.gz"
  sha256 "5ffb36754424ea26b7886a1d213c5d3b11acf5442b17fdceb5f62e3b75ab327f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a99e3c206b90ffcf3de8776c5882e1ed864a31cc7b67c851fbb2053ac9613b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c947c5df8b9215b586cfcde8d6b41811e5f76ac6c211c15f6bd31a6a84283ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3a75a9c88cfe795cbaa840dc9fc0be68edb2e830e0c834d7e8d5d200b590a1f"
    sha256 cellar: :any_skip_relocation, monterey:       "7b16c9ce22c35f9af0b97edb1cb1a5d443f8cf8997cf7162d746aee0b6f0cf54"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f748a4df0e56cb9d7f352ccd9f6dcf5da8d19f6873095b49bdfa45b6dc75e68"
    sha256 cellar: :any_skip_relocation, catalina:       "9333d1064682e5f47fbcaaad8baa3ea6c313ea39139648b3549b8449287d278a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56fc9aa90ecc763a058bcdb330d007a799f71e0c51138d78102ae0b06a1d62fe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/cloudposse/atmos/cmd.Version=#{version}'")

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

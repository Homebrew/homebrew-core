class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://github.com/cloudposse/atmos/archive/refs/tags/v1.89.0.tar.gz"
  sha256 "cbbe91daf47f543a2a3ed1b73b6e61f81cb0beeb75e4b6f82ca4b4017834a30f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "13bf6d78a5c9f7ea9c17fc9ed650de20e5f9afff936ca1b703063c04d1d20fc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "719616c26f38d051ce0c570fbe20cb6708d2fb8a3d7788340b395e60f0c6921c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "719616c26f38d051ce0c570fbe20cb6708d2fb8a3d7788340b395e60f0c6921c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "719616c26f38d051ce0c570fbe20cb6708d2fb8a3d7788340b395e60f0c6921c"
    sha256 cellar: :any_skip_relocation, sonoma:         "557b7cb8b61c937ddeda45531f2c07add156bf707949f4f641d47ab6b298ae38"
    sha256 cellar: :any_skip_relocation, ventura:        "557b7cb8b61c937ddeda45531f2c07add156bf707949f4f641d47ab6b298ae38"
    sha256 cellar: :any_skip_relocation, monterey:       "557b7cb8b61c937ddeda45531f2c07add156bf707949f4f641d47ab6b298ae38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3331de9ae79d1ae7b64b64f7447ae292ebb528838bfae7e700061174998a6e7a"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "tenv symlinks atmos binaries"

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

class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://github.com/cloudposse/atmos/archive/v1.4.12.tar.gz"
  sha256 "82da8d73eb79633c35cda9c4519b821ebde1da776efd695d172a7259cda3e73a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "966630f0dec555cc5caa56f0e00e51b6de3a2c7e619720ad18e606213fece920"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a399671f25eac9b2b29791fb351b1ccfe8b9dcd0b852655bb156c1ae1df01f00"
    sha256 cellar: :any_skip_relocation, monterey:       "eca7587c79540d04f4eca2dcb15f987a03e41f76b2b2845e7a92a9ce1eb89b34"
    sha256 cellar: :any_skip_relocation, big_sur:        "95ba67b499394d28b7e03df05136a80fa628a01db3a36362269449a98988a6f5"
    sha256 cellar: :any_skip_relocation, catalina:       "151adf4e811c90b075a977d0d19f3fea3b33fa6cd8940433d077f6a3bd702c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "695c99c70b1079924ec8661cae2c628a1534e83de1e8fdb460c544e79b3bbcc3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/cloudposse/atmos/cmd.Version=#{version}'")
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

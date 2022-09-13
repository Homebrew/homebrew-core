class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://github.com/cloudposse/atmos/archive/v1.7.1.tar.gz"
  sha256 "ef5eb558adcf4695b17620afc70dc03fc60812349b80da0095505f02112e3ecf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87409855eeb965b498df49922a77deac300bca8800bd1ebf1e611684af437e86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2c12405dcec532e3b8620efb8713f902d363fd9bc600600c415185decda8961"
    sha256 cellar: :any_skip_relocation, monterey:       "84170c07765e48429c391e2e9ebae40fbd6ead958f8cf52c4997a90a532ffcd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "09ddcd7a2de8b2605204f80817ac9932714a6a3e3ba67c688f55c3b17d71cf02"
    sha256 cellar: :any_skip_relocation, catalina:       "4e293a0bb813ecf8e91799429449717bc13545d44d275854ce67d9faf9a02d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5101861db7d85aa7a493073c495a3cb07697e326307f7f468e65a294d469338c"
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

class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://atmos.tools"
  url "https://github.com/cloudposse/atmos/archive/refs/tags/v1.235.0.tar.gz"
  sha256 "16d96c4f1c7ad230228d18dbcf802755b88e16d8180190f80c5c0fd47606e1b6"
  license "Apache-2.0"
  head "https://github.com/cloudposse/atmos.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "c18effacdb2825897e8a9c7c9caedea8b3fb86b12b6002f04e02cde7b890fcec"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7abea6336b831f7628d3281f2d400c89ce3f8fa1711165ee823910428b2d7879"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "32062686e1e5728c6df44df83236c00e580bc4fd48ab9f5a21c5590f1335677a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96308bda7a024ecd2c68795fc07c9d7df9e5cafd9cce4f68fb63fcb60acf99c6"
    sha256 cellar: :any,                 arm64_linux:       "178545f3b36d19349cd34cece826e1e37fb466b756d08e9c4fd3513f40ff22e5"
    sha256 cellar: :any,                 x86_64_linux:      "10ff825ab0a7930bca55273ca1f5ef12bb3a5dc0cc9899e2c522d0d96255d235"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # libudev
  end

  conflicts_with "tenv", because: "tenv symlinks atmos binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    ENV["GOFIPS140"] = "latest"

    system "go", "build", *std_go_args(ldflags: "-X 'github.com/cloudposse/atmos/pkg/version.Version=#{version}'")

    generate_completions_from_executable(bin/"atmos", shell_parameter_format: :cobra)
  end

  test do
    # create basic atmos.yaml
    (testpath/"atmos.yaml").write <<~YAML
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
        file: "/dev/stderr"
        verbose: false
        colors: true
    YAML

    # create scaffold
    mkdir_p testpath/"stacks"
    mkdir_p testpath/"components/terraform/top-level-component1"
    (testpath/"stacks/tenant1-ue2-dev.yaml").write <<~YAML
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
    YAML

    # create expected file
    (testpath/"backend.tf.json").write <<~JSON
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
    JSON

    system bin/"atmos", "terraform", "generate", "backend", "top-level-component1", "--stack", "tenant1-ue2-dev"
    actual_json = JSON.parse(File.read(testpath/"components/terraform/top-level-component1/backend.tf.json"))
    expected_json = JSON.parse(File.read(testpath/"backend.tf.json"))
    assert_equal expected_json["terraform"].to_set, actual_json["terraform"].to_set

    assert_match "Atmos #{version}", shell_output("#{bin}/atmos version")
  end
end

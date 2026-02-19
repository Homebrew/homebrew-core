class Kustomizer < Formula
  desc "Package manager for distributing Kubernetes configuration as OCI artifacts"
  homepage "https://github.com/stefanprodan/kustomizer"
  url "https://github.com/stefanprodan/kustomizer/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "bba48e2eed5b84111c39b34d9892ffc9f0575b6f6470d50f832f47ff6417bf03"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/kustomizer.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adbdf2f47318e66addd680e6528bb80c8891bc65baa74cbc91223c16587a4339"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18175918940bf8594cb3bcbcdc1517f32d70d57ef4900ba3ee282543f6f7344f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eefd823c09b2da2b28e381cab34fd602f0cfac1419f640382a92091a7c20a936"
    sha256 cellar: :any_skip_relocation, sonoma:        "c04691595c0fc7e67cffa06e89de8c42d4ac72762bf3ccf497778500049a3c89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd7029079ab5ac2601e34ef3f644f84498e392f8e200d0e552997b7a94150d02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "518b679442ab62cd90e797ac9ede68f336ec9557eae9ff2ce157ebbd1785cb15"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "./cmd/kustomizer"

    generate_completions_from_executable(bin/"kustomizer", shell_parameter_format: :cobra)
  end

  test do
    system bin/"kustomizer", "config", "init"
    assert_match "apiVersion: kustomizer.dev/v1", (testpath/".kustomizer/config").read

    output = shell_output("#{bin}/kustomizer list artifact 2>&1", 1)
    assert_match "you must specify an artifact repository e.g. 'oci://docker.io/user/repo'", output
  end
end

class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v0.1.70.tar.gz"
  sha256 "f4693db628fb63009133cf97ad48c7aaae764e381006a7e239a13597722ef02c"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "373cfbab7d313213da941346c7ed267adaf6181a9c739e1fdf15b24163631a21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cbdc425f362bf32e9fe2186f721b65c99dc6803b06e1d6d6677c9f82ac5c67b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "392c3f00b337b613b1e09bae294830331f29d2dc250a0f3693957072f09c09f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e575e6ec613cac80d763b87c64156958d5c2f73ca1553467f8f09117f05c94ac"
    sha256 cellar: :any_skip_relocation, ventura:        "3916ab83c510c88b540044c15b30c1fb9019ed4f82602002937abd46db489ccb"
    sha256 cellar: :any_skip_relocation, monterey:       "d5a95b2e09282a3660cf732c55b3ddda17044abdb4f7c2689066d61653eec3d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b386d6d5baefb2c5cdbc68695be5121e6224ce927a1e8ab10ea581beec5ae527"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/ocm"
    generate_completions_from_executable(bin/"ocm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm version")

    # Test that the config can be created and configuration set in it
    ENV["OCM_CONFIG"] = testpath/"ocm.json"
    system bin/"ocm", "config", "set", "pager", "less"
    config_json = JSON.parse(File.read(ENV["OCM_CONFIG"]))
    assert_equal "less", config_json["pager"]
  end
end

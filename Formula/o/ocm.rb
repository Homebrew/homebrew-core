class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v0.1.72.tar.gz"
  sha256 "c1fd5e0fdb8470dc28e596dc29845e3b7e03d02ab336d961ef3101337ee4093c"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ef219d053057e2a308e13f25b3bb23f26bc7956e1db422533947d4471f52b2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31f05076e1f80f5c5eea017d63c1b29effe9d925aee7d3d8e9debeb120bf1096"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8acf5e29de28c4196f9d6e1eefe574f3327bff13fbde835dfc34fe4ee28478b"
    sha256 cellar: :any_skip_relocation, sonoma:         "94e00690641a547328f461af1947b546b00e499ed215a7c81768f9a246519173"
    sha256 cellar: :any_skip_relocation, ventura:        "b7fe2b4066d4bb1b038a07c550cd940d016e4defc9296ed69c4e0232498a8a47"
    sha256 cellar: :any_skip_relocation, monterey:       "df60f06125db5611df5c928804cdd11c99a62a9b78bf9aaa88ba5c238b5e23de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "542d127f88f916f382344e63d23d9894f2fb88b74464a652375a35289c8b7f83"
  end

  depends_on "go" => :build

  # update to build with go1.21
  # upstream PR ref, https://github.com/openshift-online/ocm-cli/pull/587
  patch do
    url "https://github.com/openshift-online/ocm-cli/commit/0bfd59a5728ece351e60ab34e0fbade747472feb.patch?full_index=1"
    sha256 "cc5016d6c98b7b995bb331ccf6c68f393e06bdf17536e9b92ca8c18c0a7494c9"
  end

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

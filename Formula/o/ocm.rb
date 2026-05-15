class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "be4d0b086f828926a60807c0f9ab224a68d4abe68333d058d57fdca03ae4bd0d"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a4fc99c64f3f269d5a192ccfb86ffca68dd0f4b3bd49333f6c036f8eace2736"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72bccd73485ef9343d4aa9ae3e9bebe12f5f44e6f859b443b8284f52391693d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98f383e96cce429cbe762b6b007848e355b141cb04037e93d81efb3b75754d19"
    sha256 cellar: :any_skip_relocation, sonoma:        "10d260c2c12e11a588f87bb420a69e583af2f9318cdaf26938ad84e3eba0c140"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3310941e6ce644c3b4981a5bab1e5353ce333035dae96959229da97f914be62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76e29a051a81a63a7f0831f0d374e9951597f65dc0be217916d38015d703cdea"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ocm"
    generate_completions_from_executable(bin/"ocm", shell_parameter_format: :cobra)
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

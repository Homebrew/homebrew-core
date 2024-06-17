class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.87.0.tar.gz"
  sha256 "fa6856d9971d69df16eed45c37a49abb8f3a6e845ea912f714db1610f25dfc83"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcfd466204afef0de5896c597e7674a553248b62154777b2bf9e718f0c0aaad0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f753657a459856e0ae1386916ef6b62a9afcfb5ae3fba77e9f8e78b3b6058b9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b72561263301e8db23b0bb6561aba0b10350eb7920e283af6179df3edda5f068"
    sha256 cellar: :any_skip_relocation, sonoma:         "e55f865361d3f117c095a7cebee13932b28ffce9a31bd20bf9fb65217b024980"
    sha256 cellar: :any_skip_relocation, ventura:        "80e00147422330b08749669acf7de7b124be587a848b3a68f6085644d27ef3e1"
    sha256 cellar: :any_skip_relocation, monterey:       "28ab361b6d6a4e2407e36b607fb5cdb725fa9e57849ad6885f169bab261e8f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cee88dabe9acdc691cbd71830cbf959070b933cd535614747939673193fa205"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end

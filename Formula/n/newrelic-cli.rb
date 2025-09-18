class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.104.2.tar.gz"
  sha256 "28048a5bd25cae825a0b808013263577992764076a403d71e138f99cca059c7c"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c93430b41466c199137a9f4e5c9ece07342d7cea1d2422927d444929e1f2da25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d5864179a1dd6280bbc5cef4b567d40430b054b0711c60c4f5c83b5dd3c46a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fd4e7fc6ebe39c7af1e4c120b98f778343d7dcd8298206078e86f104f846a90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "029884135ddd47aba3b203099277893ed923a3576d162124c29dcf1020ae4f2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc9c0db72b1fbb2c1c3272862cd06da93b4eae40b2f628635357e10a3000523d"
    sha256 cellar: :any_skip_relocation, ventura:       "466f266ae2acac4a5979171abea687e057ac0cdd8dbfcfec6d01b3aa98a113db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "421c4c10d1285a4af8c8e22bf5b372b80346376acd532b95347c70ec499a2bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa93be62981964b27fb7dbb19e461ef72f8b78f33b447be8d3c66d63d29f7f30"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end

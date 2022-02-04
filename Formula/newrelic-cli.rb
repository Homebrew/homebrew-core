class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.20.tar.gz"
  sha256 "c7ab73ec8919231f4f4d563efdb629a48ab3666fa1c3f2f68b91b146710f552f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c97223b7cfed359c059f95e3a44021078ec6e9a6fde7681f000c0825f5062cea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa663ad1ae1973e4d3ed89995585a2481a8662abf8bffb7eb69ae5407a4b73b5"
    sha256 cellar: :any_skip_relocation, monterey:       "2cda12ecdd0c9b802ed4389002e3c3c48cac71b3b6c81d70809c53c814a0d636"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f0766e6aa26c71532bb7826ac0740aa1202fb4737f5ec6e42bf91895f60cc5a"
    sha256 cellar: :any_skip_relocation, catalina:       "16a1459acc852ce338df867f1d7fb8350a0dd267a2e7f8c31667050ad609c653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b80dee6fdedf99cda9a9dfd0d5c0aa9abada90ff21445d408a6e943d337de42d"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "fish")
    (fish_completion/"newrelic.fish").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end

class Anyenv < Formula
  desc "All in one for **env"
  homepage "https://anyenv.github.io/"
  url "https://github.com/anyenv/anyenv/archive/v1.1.4.tar.gz"
  sha256 "efb5663ea44ba53c692bb1db439f4b9cf69099614030d0950fdd083f07a2e3c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64a65deada2b73eea41aaf1072d015c193e46cc38d524e3770d8e319b56b54fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64a65deada2b73eea41aaf1072d015c193e46cc38d524e3770d8e319b56b54fe"
    sha256 cellar: :any_skip_relocation, monterey:       "3cbde52463957a85f70e02c7c4e4ae793a3d5cbd6a44db6ec930f6f370db8b66"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cbde52463957a85f70e02c7c4e4ae793a3d5cbd6a44db6ec930f6f370db8b66"
    sha256 cellar: :any_skip_relocation, catalina:       "3cbde52463957a85f70e02c7c4e4ae793a3d5cbd6a44db6ec930f6f370db8b66"
    sha256 cellar: :any_skip_relocation, mojave:         "3cbde52463957a85f70e02c7c4e4ae793a3d5cbd6a44db6ec930f6f370db8b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64a65deada2b73eea41aaf1072d015c193e46cc38d524e3770d8e319b56b54fe"
  end

  def install
    prefix.install %w[bin completions libexec]
  end

  test do
    Dir.mktmpdir do |dir|
      profile = "#{dir}/.profile"
      File.open(profile, "w") do |f|
        content = <<~EOS
          export ANYENV_ROOT=#{dir}/anyenv
          export ANYENV_DEFINITION_ROOT=#{dir}/anyenv-install
          eval "$(anyenv init -)"
        EOS
        f.write(content)
      end

      cmds = <<~EOS
        anyenv install --force-init
        anyenv install --list
        anyenv install rbenv
        rbenv install --list
      EOS
      cmds.split("\n").each do |cmd|
        shell_output(". #{profile} && #{cmd}")
      end
    end
  end
end

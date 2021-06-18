class Anyenv < Formula
  desc "All in one for **env"
  homepage "https://anyenv.github.io/"
  url "https://github.com/anyenv/anyenv/archive/v1.1.3.tar.gz"
  sha256 "df792ebb210417accb7d39cf5b00fe8a4b621058f5dccc4c286ae51e641fc666"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e29c4f22d906b1a84c4ba3a088d5e4ffee99254cd528fb94e1a1a3d8d60bb307"
    sha256 cellar: :any_skip_relocation, big_sur:       "381377f93374c1b1c1b0154c5f08c91dbf33a948a2ac47933a4bbd5d7c0d8ee8"
    sha256 cellar: :any_skip_relocation, catalina:      "381377f93374c1b1c1b0154c5f08c91dbf33a948a2ac47933a4bbd5d7c0d8ee8"
    sha256 cellar: :any_skip_relocation, mojave:        "381377f93374c1b1c1b0154c5f08c91dbf33a948a2ac47933a4bbd5d7c0d8ee8"
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
        shell_output("source #{profile} && #{cmd}")
      end
    end
  end
end

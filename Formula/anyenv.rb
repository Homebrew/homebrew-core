class Anyenv < Formula
  desc "All in one for **env"
  homepage "https://anyenv.github.io/"
  url "https://github.com/anyenv/anyenv/archive/v1.1.4.tar.gz"
  sha256 "efb5663ea44ba53c692bb1db439f4b9cf69099614030d0950fdd083f07a2e3c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e29c4f22d906b1a84c4ba3a088d5e4ffee99254cd528fb94e1a1a3d8d60bb307"
    sha256 cellar: :any_skip_relocation, big_sur:       "381377f93374c1b1c1b0154c5f08c91dbf33a948a2ac47933a4bbd5d7c0d8ee8"
    sha256 cellar: :any_skip_relocation, catalina:      "381377f93374c1b1c1b0154c5f08c91dbf33a948a2ac47933a4bbd5d7c0d8ee8"
    sha256 cellar: :any_skip_relocation, mojave:        "381377f93374c1b1c1b0154c5f08c91dbf33a948a2ac47933a4bbd5d7c0d8ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9125ca9a0f5816044c54fb7cf41366633ef78d233172d3039e7f9bd172847874"
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

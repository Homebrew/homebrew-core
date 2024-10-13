class Anyenv < Formula
  desc "All in one for **env"
  homepage "https://anyenv.github.io/"
  url "https://github.com/anyenv/anyenv/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "ed086fb8f5ee6bd8136364c94a9a76a24c65e0a950bb015e1b83389879a56ba8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f0c5c9923085a2a772fa142aa3d1ddb3e02015553306c6f3ce7747a9bc4d9e64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e462542223d5607086423b094fc86298425826c8f82c8d9566e9e1598ec3017d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fcafa1cbde4f24bb3e88597312c279ad4ad34e5ab80b51a2e1e96afb8b97157"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fcafa1cbde4f24bb3e88597312c279ad4ad34e5ab80b51a2e1e96afb8b97157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fcafa1cbde4f24bb3e88597312c279ad4ad34e5ab80b51a2e1e96afb8b97157"
    sha256 cellar: :any_skip_relocation, sonoma:         "73879c37bbfdac38f5f3057182da253d44732fa54c77cb483c8a2cbae9897bdd"
    sha256 cellar: :any_skip_relocation, ventura:        "e7a9bd58702840c6aee47e42ff2691681721a494a47cceac00cf10e1b1748879"
    sha256 cellar: :any_skip_relocation, monterey:       "e7a9bd58702840c6aee47e42ff2691681721a494a47cceac00cf10e1b1748879"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7a9bd58702840c6aee47e42ff2691681721a494a47cceac00cf10e1b1748879"
    sha256 cellar: :any_skip_relocation, catalina:       "e7a9bd58702840c6aee47e42ff2691681721a494a47cceac00cf10e1b1748879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fcafa1cbde4f24bb3e88597312c279ad4ad34e5ab80b51a2e1e96afb8b97157"
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

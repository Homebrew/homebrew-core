class Anyenv < Formula
  desc "All in one for **env"
  homepage "https://anyenv.github.io/"
  url "https://github.com/anyenv/anyenv/archive/v1.1.0.tar.gz"
  sha256 "43d51b31b4efccc52cd48290d565d33ee8ef9fc9dbcf635909481744e9898617"

  bottle do
    cellar :any_skip_relocation
    sha256 "f36c96fb9dce2d36e6d67aaf1aa8fc846983333b101816ff6a78ae5b68135a08" => :mojave
    sha256 "f36c96fb9dce2d36e6d67aaf1aa8fc846983333b101816ff6a78ae5b68135a08" => :high_sierra
    sha256 "021fa6c226fdd920311d5fb871dd8befe70690b14bd2e03365059f0a011973f8" => :sierra
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

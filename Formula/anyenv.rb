class Anyenv < Formula
  desc "All in one for **env"
  homepage "https://anyenv.github.io/"
  url "https://github.com/anyenv/anyenv/archive/v1.1.2.tar.gz"
  sha256 "414dd42b262cc0ddb8ce77f2f2971943b55a045286a85232372e42d60b16389f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e81a1695047a8db888363ae4e81c54e2c62aa0da217f8d34bbb22a7fd5da6d11" => :big_sur
    sha256 "dcd5240a828a78c1e6df3e4cb9c4fcff5ce1c1d7b5699aff350eba25ca28ab15" => :arm64_big_sur
    sha256 "d07da85e43b8fca089c90ca923593f4d96732f5b05f6a20026f0d219d68bba3b" => :catalina
    sha256 "d07da85e43b8fca089c90ca923593f4d96732f5b05f6a20026f0d219d68bba3b" => :mojave
    sha256 "d07da85e43b8fca089c90ca923593f4d96732f5b05f6a20026f0d219d68bba3b" => :high_sierra
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

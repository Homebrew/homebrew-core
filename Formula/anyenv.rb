class Anyenv < Formula
  desc "All in one for **env"
  homepage "https://anyenv.github.io/"
  url "https://github.com/anyenv/anyenv/archive/v1.1.2.tar.gz"
  sha256 "414dd42b262cc0ddb8ce77f2f2971943b55a045286a85232372e42d60b16389f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d2ce77ba521894c567d8ef6c95def07eff48d38680f259d2f8f5b5c3654ac16" => :catalina
    sha256 "0bc3795db6ae8df4151de4fb15be7122a7c0c416d4bc553976e61b23cb9e3c61" => :mojave
    sha256 "0bc3795db6ae8df4151de4fb15be7122a7c0c416d4bc553976e61b23cb9e3c61" => :high_sierra
    sha256 "c4073892fe99575a1f23eb24714392f098c2980eaaf465a9a8641d955da08306" => :sierra
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

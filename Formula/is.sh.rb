class IsSh < Formula
  desc "Human readable conditions for bash"
  homepage "https://github.com/qzb/is.sh"
  url "https://github.com/qzb/is.sh/archive/v1.0.1.tar.gz"
  sha256 "30e5cdce967e6051be7f4afd1422fa12157d7d73af0572c4127ff52f788adb04"

  def install
    bin.install "is.sh"
    bin.install_symlink bin/"is.sh" => "is"
    share.install "tests"
  end

  test do
    ["is", "is.sh"].each do |cmd|
      shell_output("#{share}/tests/tests.sh #{cmd}")
    end
  end
end

class Dog < Formula
  desc "Command-line application that executes tasks"
  homepage "https://github.com/dogtools/dog"
  url "https://github.com/dogtools/dog/releases/download/v0.1.0/dog-v0.1.0.tar.gz"
  sha256 "f584e9d074b5d08a3e2cd5707cfa8961cc3dfa27102a78cc287f86dd061cd2fe"

  def install
    prefix.install "darwin_amd64/dog"
  end

  test do
    system "dog"
  end
end

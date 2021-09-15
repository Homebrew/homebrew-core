class Betty < Formula
  desc "English-like interface for the command-line"
  homepage "https://github.com/pickhardt/betty"
  url "https://github.com/pickhardt/betty/archive/v0.1.7.tar.gz"
  sha256 "ed71e88a659725e0c475888df044c9de3ab1474ff483f0a3bb432949035e62d3"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cdae1d186d5d81c47c8c3f603e379fb563e4d63844966a14c6c4c2f7319a5871"
  end

  def install
    libexec.install "lib", "main.rb" => "betty"
    bin.write_exec_script libexec/"betty"
  end

  test do
    system bin/"betty", "what is your name"
    system bin/"betty", "version"
  end
end

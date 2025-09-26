class Infat < Formula
  desc "Command-line tool to manage license files and headers in software projects"
  homepage "https://github.com/philocalyst/infat"
  version "3.0.1"
  license "MIT"
  revision 1
  head "https://github.com/philocalyst/infat.git", branch: "main"

  depends_on macos: ">= :monterey"

  author = "philocalyst"

  livecheck do
    url :stable
    strategy :github_latest
  end

  if Hardware::CPU.arm?
    url "https://github.com/#{author}/infat/releases/download/v#{version}/infat-aarch64-apple-darwin.tar.gz"
  else
    url "https://github.com/#{author}/infat/releases/download/v#{version}/infat-x86_64-apple-darwin.tar.gz"
  end

  def install
    bin.install "infat"
    bash_completion.install "infat.bash" => "infat"
    fish_completion.install "infat.fish"
    zsh_completion.install "_infat"
  end
  
  test do
    system bin / "infat", "--version"
    system bin / "infat", "--help"
  end
end

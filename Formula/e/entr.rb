class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "https://eradman.com/entrproject/"
  url "https://eradman.com/entrproject/code/entr-5.6.tar.gz"
  sha256 "0222b8df928d3b5a3b5194d63e7de098533e04190d9d9a154b926c6c1f9dd14e"
  license "ISC"
  head "https://github.com/eradman/entr.git", branch: "master"

  livecheck do
    url "https://eradman.com/entrproject/code/"
    regex(/href=.*?entr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c207eaf32b44f3c5f752a0e7c6ed75effe56c103ff269ea778cccb3e37215ead"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7ee2faf06f4a2415de5e7e6f88d240b0d1dc6482dc5d4f6f3a637419cb5a432"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf88dbab403da96c573a4a2a4fb7be87f395546b7224bd7cb97c73a67497b9de"
    sha256 cellar: :any_skip_relocation, sonoma:         "422c7751e92482465f88929cbb69f47ce5c26051f8d92c5695ae8856febd5838"
    sha256 cellar: :any_skip_relocation, ventura:        "ff34aacd4522000c755f6edbd062a0ea93f5e175678c5438d60a4d35516dcc70"
    sha256 cellar: :any_skip_relocation, monterey:       "947961bf300a2918d98a707b2a3b9ac1e21df4aa69afaf58d3661570e051e7c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd267f9c233a6cfe5845a3bae22cfbec02bdfd73634a51dfaf2257ddb435ae08"
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -n -p -d echo 'New File'", testpath).strip
  end
end

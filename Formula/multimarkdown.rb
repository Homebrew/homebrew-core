class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "https://fletcher.github.io/MultiMarkdown-6/"
  url "https://github.com/fletcher/MultiMarkdown-6/archive/6.6.0.tar.gz"
  sha256 "6496b43c933d2f93ff6be80f5029d37e9576a5d5eacb90900e6b28c90405037f"
  license "MIT"
  head "https://github.com/fletcher/MultiMarkdown-6.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3061fd1e30663e1fe42fb3f9e92530f8a2e8cba671ed67863639d1c6cef8e680"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c377c5976fff15a469b330470febc8b7db8f695b597e588fd35e975fe17010a5"
    sha256 cellar: :any_skip_relocation, monterey:       "694f10e1a17f294485223e557a27cb7f9ce8025b202197caf2698257a26e1e36"
    sha256 cellar: :any_skip_relocation, big_sur:        "15b87bf8b7be554761d0114af63d3789df6db6cb58616afc408f569ea8ac50d0"
    sha256 cellar: :any_skip_relocation, catalina:       "f4a26eb7603d38d0f67db4edbde56334fce2024c1c78fd5f49a7b8b69ba48683"
    sha256 cellar: :any_skip_relocation, mojave:         "f095caaf1f01dd0611afcdfc77252dc2f21a3d89f8e41210e4d00307b835eb2d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "308d597802afebc412f38df92dda2b98cef91845bb0e9c8e27d1bd2d38ee9d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a385235978ad98fcd8a53d03ed59e101d257b835e49782ecd88d4d551fdbfec"
  end

  depends_on "cmake" => :build

  conflicts_with "mtools", because: "both install `mmd` binaries"
  conflicts_with "markdown", because: "both install `markdown` binaries"
  conflicts_with "discount", because: "both install `markdown` binaries"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "multimarkdown"
    end

    bin.install Dir["scripts/*"].reject { |f| f.end_with?(".bat") }
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"multimarkdown", "foo *bar*\n")
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"mmd", "foo *bar*\n")
  end
end

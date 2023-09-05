class Mp3check < Formula
  desc "Tool to check mp3 files for consistency"
  homepage "https://code.google.com/archive/p/mp3check/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mp3check/mp3check-0.8.7.tgz"
  sha256 "27d976ad8495671e9b9ce3c02e70cb834d962b6fdf1a7d437bb0e85454acdd0e"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17d0d21d24eae65edccb72577dbc578d89d1660a7c95eda9c521c2ac27636f6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae74bb7b036881a560bb8de9ab44ef31cbdfc1d9c710fed0183de39c2fc5272f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0c683cf446e72e17104142e290f2bf3fea6fd01fcf1534ba1c61c7d5a85bb05"
    sha256 cellar: :any_skip_relocation, ventura:        "8223c78bae026c58b1e0407a174a3614201b7bb909fcb8ad699973c61ba3406e"
    sha256 cellar: :any_skip_relocation, monterey:       "f798432e9eae61bdf47178e912582b02d9482640375174d26714a59185e626db"
    sha256 cellar: :any_skip_relocation, big_sur:        "943c98e4c93c300a781541927303207319ba030227a0e1dd123fd83abb782ad0"
    sha256 cellar: :any_skip_relocation, catalina:       "a98298c030d1ee1a28e2227ed41970fcad21d2af6486c471d045b07010ac232b"
    sha256 cellar: :any_skip_relocation, mojave:         "e19a17b2360f7a7974fe798cc68a12735155b14c68bb8c0d7a13439dd3fa5a29"
    sha256 cellar: :any_skip_relocation, high_sierra:    "99c5e5b8458a0cda5f50d92d858ccbd968f059a3b639130a3378c499331e427e"
    sha256 cellar: :any_skip_relocation, sierra:         "2846b7bd6201b58c40ce9b6193a929c5404fcbe77e97854876e53bba5c9d0d82"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d63ba27cfd87cf1f8b1871fe8b0531882c037f116933cbc59caf429dfeaab735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72769405fb206a5851bac35ea59bc0d4b7663c57a62cdc8bfa172fa21379130e"
  end

  def install
    ENV.deparallelize
    # The makefile's install target is kinda iffy, but there's
    # only one file to install so it's easier to do it ourselves
    system "make"
    bin.install "mp3check"
  end

  test do
    assert version.to_s, shell_output("#{bin}/mp3check --version")
  end
end

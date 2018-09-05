class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.4.2.tar.gz"
  sha256 "a3ce478f277e2c2a84661ecf92ad42ffeceb8836bc6e5d182f7fad7b6ec9ddd8"

  bottle do
    cellar :any_skip_relocation
    sha256 "5de5f9fa7154502ca59b4073880768cbab9c0775a619e09e10269a8798df3395" => :mojave
    sha256 "795f48b4378f51ce10359d2fb97605bf5a3edf090f9330850b417b0d232da3eb" => :high_sierra
    sha256 "04d6dd005bfc1c66bc3158ed21ec5c0ddb95b9db95652aa6a267d57d93472d1d" => :sierra
    sha256 "c6414abb33717233a59591a3100f7008e81bc1a94f68f09854cb319aa26a7dee" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/caarlos0/fork-cleaner"
    dir.install buildpath.children
    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "make"
      bin.install "fork-cleaner"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end

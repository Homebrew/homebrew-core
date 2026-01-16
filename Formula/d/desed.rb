class Desed < Formula
  desc "Debugger for Sed"
  homepage "https://soptik.tech/articles/building-desed-the-sed-debugger.html"
  url "https://github.com/SoptikHa2/desed/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "73c75eaa65cccde5065a947e45daf1da889c054d0f3a3590d376d7090d4f651a"
  license "GPL-3.0-or-later"
  head "https://github.com/SoptikHa2/desed.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96d7601c2d5624d9675565db1db7cf42269d14f4c0020658042019738a126f45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a633dbad86f2cacfe936a808372d3259ecbde4fcbb100d444d4dfe04b846c848"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f2a66cf69929b5532c8a46f34b39bb89edde7339f0e60523f613af7443e9b84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c94d25fc45f6e6e18e492b7a1b0a99bc050010ef581964235718147f41a8721d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2160dd4cfb4d6c16d5563112a6871a012c2968e2313514c48cf7323fa2d1e714"
    sha256 cellar: :any_skip_relocation, ventura:       "8d561d9e6c8f3d55f5a708ce24cc786b2975f227ec86414cf312409adc5130c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d7939fa70a8187c637bc200bbdcf9f3ff97950032b92425a2c9ccdbdb8141f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74c7143b9c97e0dfa4bd338b665434834ffd17d5c1cd3582f346ae7498b5f2ad"
  end

  depends_on "rust" => :build
  depends_on "gnu-sed" => :test

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "desed.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/desed --version")
    # desed is a TUI application
    # Just test that it opens when files are provided
    assert_match "No such file or directory", shell_output("#{bin}/desed test.sed test.txt 2>&1")

    (testpath/"test.txt").write <<~EOS
      1 2 3 4 5 1 2 3 4 5
      232 1 4 526 2 1 1 5
    EOS
    (testpath/"test.sed").write <<~SED
      =
      :bbb
      s/1/2/
      t bbb
      H
      p
      G
      G
      p
    SED

    begin
      pid = spawn bin/"desed", testpath/"test.sed", testpath/"test.txt"
      sleep 2
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

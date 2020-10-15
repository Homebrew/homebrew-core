class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.18.0.tar.gz"
  sha256 "0ebe67e543226721c3802dd56db0355575accf50f10c09fe188bbb604aa8c193"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "502616ec44ca052029c4387ee468fb67d1dea019cce66f3e26131cb3a2889ee7" => :catalina
    sha256 "c2564cec7c18b2a57ea1bb58b8f5b997bc46bc2d0cc42765243ff02084fe311e" => :mojave
    sha256 "5846307d054fe63c6c142388753356f7bb12ff378d2684c8d1dcec2128be0a82" => :high_sierra
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "xz"

  on_linux do
    depends_on "gmp"
  end

  def install
    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    system "stack", "-j#{jobs}", "build"
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end

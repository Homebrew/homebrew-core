class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.net/bowtie2/index.shtml"
  url "https://github.com/BenLangmead/bowtie2/archive/refs/tags/v2.5.5.tar.gz"
  sha256 "e38d1833ec235ca27fa57589d32d897c9addf87085b7cb7bc978662954662da2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a579b7a13533d8e7a1eb74bed904affcae752eaa0e89599e54cb6c475b1806c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85d97a5b3966b23bab047b167357606dc73a5109d3f0b16579e5c9d9506ead46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efd260694be791dbf2ee3faa0b1d4ab279380d79a32d03f67c19d5cdafec78df"
    sha256 cellar: :any_skip_relocation, sonoma:        "6959f00c38e6a7158236ece9d7da060db011b8bf30ebe7398688696a4c9d8c2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "315aaa40fec3ebd1ff2082647b49922f359707dcef169ac25f6d5bf5bad7c1e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f156398c3ed61a93d970f69a818de0d4c29ab851a81501fcc7ecad6a8d547565"
  end

  uses_from_macos "perl"
  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  on_arm do
    depends_on "simde" => :build
  end

  def install
    ENV.runtime_cpu_detection

    if OS.mac? && Hardware::CPU.intel?
      # Apple clang rejects "__builtin_cpu_supports(\"x86-64-v3\")".
      # Use AVX2 feature probing for runtime dispatch to the `-v256` binaries.
      inreplace "bowtie_main.cpp", '"x86-64-v3"', '"avx2"'
    end

    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "example", "scripts"
  end

  test do
    system bin/"bowtie2-build",
           "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert_path_exists testpath/"lambda_virus.1.bt2", "Failed to create viral alignment lambda_virus.1.bt2"
  end
end

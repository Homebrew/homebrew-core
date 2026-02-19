class Libmonome < Formula
  desc "Library for easy interaction with monome devices"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/refs/tags/v1.4.9.tar.gz"
  sha256 "145b51318f8c4895273d2a8695e20f61730c242428dacb7bff2c132a7d8e08b8"
  license "ISC"
  head "https://github.com/monome/libmonome.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b31308553453c848b03425ff8b6e6caa6ba3390707ad393f2b40e40f289154c0"
    sha256 cellar: :any,                 arm64_sequoia: "a8f7827e9fce6c88f2c91abeadd818b0ae33b849509afa93d7b502ad1c336fb7"
    sha256 cellar: :any,                 arm64_sonoma:  "a9dc02e09461603b7c834ed207cab657858532729875671b177336cd56166458"
    sha256 cellar: :any,                 sonoma:        "c783f385c91abc6cf2cbc6392011309e3971d4d0614f0040b859871d874ecc1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abfeec4974ffd9cd22459e1ba90a8fba0d017e43b6c292872e11113c98c5f836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24fa734badf36be01d30e10a64e180df8a35a02820efe6797d5766879eddc077"
  end

  depends_on "liblo"

  uses_from_macos "python" => :build

  def install
    # Workaround for arm64 linux, issue ref: https://github.com/monome/libmonome/issues/82
    ENV.append_to_cflags "-fsigned-char" if OS.linux? && Hardware::CPU.arm?

    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"

    pkgshare.install Dir["examples/*.c"]
  end

  test do
    assert_match "failed to open", shell_output("#{bin}/monomeserial", 1)
  end
end

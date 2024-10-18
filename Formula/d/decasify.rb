class Decasify < Formula
  desc "Utility for casting strings to title-case according to locale-aware style guides"
  homepage "https://github.com/alerque/decasify"
  url "https://github.com/alerque/decasify/releases/download/v0.6.0/decasify-0.6.0.tar.zst"
  sha256 "01293c3300692bc4596ad8f91e9dbd0d0adb0bccf35a5ebac04047ce693d3c0b"
  license "LGPL-3.0-only"

  head do
    url "https://github.com/alerque/decasify.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jq" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    configure_args = %w[
      --disable-silent-rules
    ]

    system "./bootstrap.sh" if build.head?
    system "./configure", *configure_args, *std_configure_args
    system "make"
    system "make", "install"

    (libexec/"bin").install bin/"decasify"
    (bin/"decasify").write_env_script libexec/"bin/decasify", env
  end

  test do
    assert_match "decasify #{version.to_s.match(/\d\.\d\.\d/)}", shell_output("#{bin}/decasify --version")
    assert_match "Ben ve İvan", shell_output("#{bin}/decasify -l tr -c title 'ben VE ivan'")
  end
end

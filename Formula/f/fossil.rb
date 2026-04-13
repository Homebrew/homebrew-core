class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.28/fossil-src-2.28.tar.gz"
  sha256 "84c18824ca227e7602d2408b663c3747f754ad306ed5c73ddab959d6589538a6"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "4b4e87850124a9ac1e744a1666dcb130559b2a42211c88fd6638bf4aaf94bedd"
    sha256                               arm64_sequoia: "374946eaa9167456cb3a8afdfbfd682f6b3d1fec6f824e8f5675fbb39b6affaa"
    sha256                               arm64_sonoma:  "5257caee28e4c79d291c042d068d6d6224516349af37bbbb44364502a19d12ba"
    sha256 cellar: :any,                 sonoma:        "a0b0f4dd1d52c16dfc8c86eef57c54931c3f6a63b8ea823d57a81250f823579d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "527bcb7891799919f0b6219d088421a044f5af220ae06c2d1305444014a12701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbd65f925258794188c892a90210dd3c84d48feef1c435c7d432a2f7cfec8f7b"
  end

  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
      "--disable-fusefs",
    ]

    args << if OS.mac? && MacOS.sdk_path_if_needed
      "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
    bash_completion.install "tools/fossil-autocomplete.bash" => "fossil"
    zsh_completion.install "tools/fossil-autocomplete.zsh" => "_fossil"
  end

  test do
    system bin/"fossil", "init", "test"
  end
end

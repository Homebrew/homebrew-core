class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-22.01.8.tar.gz"
  sha256 "a097e8cc8eca0152ed9527c1caf73e5c9c83f6ada1d313a25b80fe79072fbad8"
  license all_of: ["GPL-2.0-only", "LGPL-2.0-only", "MIT"]
  revision 1

  livecheck do
    url "https://dl.mercurylang.org/"
    regex(/href=.*?mercury-srcdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe009114d3e453c085f4956f00a894e7262ca8834eff20971202ffdac952e23f"
    sha256 cellar: :any,                 arm64_sequoia: "5a8c953a905318645766c0457bbe546a8bc7b0d65b04d98c838ddf996f5d885a"
    sha256 cellar: :any,                 arm64_sonoma:  "8132aa81235d40e482e84630d4b6d8e037ec0176fbbf7dd0b7a2457ef781ea7a"
    sha256 cellar: :any,                 arm64_ventura: "ff7e02ae589247c4a6c07d1f4c0a8277d000188d8c36920ca1769073b759d562"
    sha256 cellar: :any,                 sonoma:        "70c6cd977d7485a229575d4a1db077245a7a1984b467e92f5061ce363aa54922"
    sha256 cellar: :any,                 ventura:       "3a970961faf6783d4e1129368cda20f58ee36edab81a62c0eb23b99481b14d51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b17d67e53415840a6362c3a43facb91ac8301fa31ea183fd365a170bc2d5fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89b71d74d5df6b4a4c1efb4c0a68045c4c397967d88fcd8fcf44125d60d8ffad"
  end

  depends_on "openjdk"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "readline"
  end

  def install
    # Make readline/libedit usage explicit rather than relying on automatic detection
    args = if OS.mac?
      %w[--without-readline --with-editline]
    else
      %w[--with-readline --without-editline]
    end
    system "./configure", *args, *std_configure_args
    system "make", "install", "PARALLEL=-j"

    # Remove batch files for windows.
    bin.glob("*.bat").map(&:unlink)
  end

  test do
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.m"
    path.write <<~EOS
      :- module hello.
      :- interface.
      :- import_module io.
      :- pred main(io::di, io::uo) is det.
      :- implementation.
      main(IOState_in, IOState_out) :-
          io.write_string("#{test_string}", IOState_in, IOState_out).
    EOS

    system bin/"mmc", "-o", "hello_c", "hello"
    assert_path_exists testpath/"hello_c"

    assert_equal test_string, shell_output("#{testpath}/hello_c")

    system bin/"mmc", "--grade", "java", "hello"
    assert_path_exists testpath/"hello"

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end

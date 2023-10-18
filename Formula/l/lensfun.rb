class Lensfun < Formula
  include Language::Python::Shebang

  desc "Remove defects from digital images"
  homepage "https://lensfun.github.io/"
  license all_of: [
    "LGPL-3.0-only",
    "GPL-3.0-only",
    "CC-BY-3.0",
    :public_domain,
  ]
  version_scheme 1
  head "https://github.com/lensfun/lensfun.git", branch: "master"

  stable do
    url "https://github.com/lensfun/lensfun/archive/refs/tags/v0.3.4.tar.gz"
    sha256 "dafb39c08ef24a0e2abd00d05d7341b1bf1f0c38bfcd5a4c69cf5f0ecb6db112"

    # upstream cmake build change, https://github.com/lensfun/lensfun/pull/1983
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/86b624c/lensfun/0.3.4.patch"
      sha256 "8cc8af937d185bb0e01d3610fa7bb35905eb7d4e36ac4c807a292f1258369bdb"
    end
  end

  # Versions with a 90+ patch are unstable and this regex should only match the
  # stable versions.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+(?:\.(?:\d|[1-8]\d+)(?:\.\d+)*)?)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "83687062a7ded4ce3a1c499a341191641a3b42e6ed69134b40219ebd1c63c112"
    sha256 arm64_ventura:  "4a99ed8713c56bd81fec4c7f35881a5c5cc83ce73e23b08f8f82e7fcd922b978"
    sha256 arm64_monterey: "4a9857407b226accdc5d8790c3c3dbfbad4ff8483d55e9f78cf534e81cad8bba"
    sha256 arm64_big_sur:  "d546dd5e1c72fd2a067b0525665925cc357a80c15c1b1f368370e7f3b8405940"
    sha256 sonoma:         "13fc156fdc63d24ab4d5d01b45236f077f8ba78d4c7063e22266f5e80a19dbda"
    sha256 ventura:        "6e16b67dc7484b899c0aaba0abd336dbdadcae77c8cbc8b952b6751c25b0acd3"
    sha256 monterey:       "eb05f7aa7df729187805b00bfdcc2493d8dfb08edc6602f70efcb41d84931b83"
    sha256 big_sur:        "bdb3fecd6744dbb7f16910351e3f950082bc5ee5a40c27bf0de833a5fa3986a6"
    sha256 x86_64_linux:   "2211b5b79be1624137ceb4a197bcc8180151e13c26930016428102101a461beb"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libpng"
  depends_on "python@3.11"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rewrite_shebang detected_python_shebang,
      bin/"lensfun-add-adapter", bin/"lensfun-convert-lcp", bin/"lensfun-update-data"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end

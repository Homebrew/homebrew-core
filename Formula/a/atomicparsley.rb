class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://github.com/wez/atomicparsley"
  url "https://github.com/wez/atomicparsley/archive/refs/tags/20240608.083822.1ed9031.tar.gz"
  version "20240608.083822.1ed9031"
  sha256 "5bc9ac931a637ced65543094fa02f50dde74daae6c8800a63805719d65e5145e"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/wez/atomicparsley.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70e708c09ef763d61b8bba8195426c515a20408adbb3addb3c9e96316ad6f769"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09957d7903f650b1f90891fe07b25109750396b1879ecc93427cef1d141a512d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec3992fb93db9d6927cc5261cadb7b4e03f3802136c0c5fefefa0ac96fe934b5"
    sha256 cellar: :any_skip_relocation, tahoe:         "73023ae7c2237fdddd0966b6fefc4374167fc240ad8690ed67ab8a2438ce028b"
    sha256 cellar: :any_skip_relocation, sequoia:       "8412b774a3cfdc2c88d1f24fd63cb1b9c54cef0c6d25c7eeed355b466d3debbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c590c6fdb51209e2b36b6bf290d72215cf768c6816da58f483021af4c8df5c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "598edb090c4b9222ca0ebb0f6514acf735f9311e8fc03f3afcb0eb8a92210a3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05df26f40020528cbc1df0b9338257fd3bb2b2085c125985015be4b276e59b01"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/AtomicParsley"
  end

  test do
    cp test_fixtures("test.m4a"), testpath/"file.m4a"

    system bin/"AtomicParsley", testpath/"file.m4a", "--artist", "Homebrew", "--overWrite"
    output = shell_output("#{bin}/AtomicParsley file.m4a --textdata")
    assert_match "Homebrew", output
  end
end

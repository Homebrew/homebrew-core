class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/SimonKagstrom/kcov.git", branch: "master"

  stable do
    url "https://github.com/SimonKagstrom/kcov/archive/refs/tags/v43.tar.gz"
    sha256 "4cbba86af11f72de0c7514e09d59c7927ed25df7cebdad087f6d3623213b95bf"

    patch do
      url "https://github.com/SimonKagstrom/kcov/commit/698f612b01e776dfbc4bab11d320097425918423.patch?full_index=1"
      sha256 "9465fa31cde08a449e03b8b9ac6149d2ad6eb337189c348000def5eabd58d519"
      type :backport
      resolves "https://github.com/SimonKagstrom/kcov/issues/475"
    end
  end

  # We check the Git tags because, as of writing, the "latest" release on GitHub
  # is a prerelease version (`pre-v40`), so we can't rely on it being correct.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "dc4911b119a8ef544c99f9f8fb7328540d4628813eff29982a4512f034ded671"
    sha256 arm64_tahoe:       "5e54bdf13adaab924aa1b999dbfbd057f002b874ddc8bc07a9420948d827b62d"
    sha256 arm64_sequoia:     "c141d20ae6e2e32741d2f8de9a9557bd95f64fab020c6115380af6b6e3804acd"
    sha256 arm64_linux:       "f1943b4533447ff45e052a4274bf90c335763cda65a69600731cd1ed0983750d"
    sha256 x86_64_linux:      "7c911603055d1dab3d6c52cb19006ab23b91d5bafbf00d8736a483f014a8e257"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "dwarfutils"
  depends_on "openssl@4"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "elfutils"
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    system "cmake", "-S", ".", "-B", "build", "-DSPECIFY_RPATH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.bash").write <<~BASH
      #!/bin/bash
      echo "Hello, world!"
    BASH

    system bin/"kcov", testpath/"out", testpath/"hello.bash"
    assert_path_exists testpath/"out/hello.bash/coverage.json"
  end
end

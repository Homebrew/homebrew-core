class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  url "https://github.com/SimonKagstrom/kcov/archive/v40.tar.gz"
  sha256 "6b1c11b066d57426d61375a31c3816f1fcd2610b447050c86d9920e22d5200b3"
  license "GPL-3.0-or-later"
  head "https://github.com/SimonKagstrom/kcov.git", branch: "master"

  # We check the Git tags because, as of writing, the "latest" release on GitHub
  # is a prerelease version (`pre-v40`), so we can't rely on it being correct.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "126b48dce88672499df00ffea98e9041d24ac86af286ff3648e8c5fd2c2ee86c"
    sha256 arm64_monterey: "ac1c2c3b59a021af7822ed720ef499aee7dfd3650374c2b87afad5f03c7e7e20"
    sha256 arm64_big_sur:  "bdb4c013e4153a73e3f18b3c5dce933719946491ab23642c0f30ed63400e051d"
    sha256 ventura:        "3db3a516946ba0dd0f2c744f962bac584441a48c60a5ca4679c1594675ed02ac"
    sha256 monterey:       "994883172334f1c2279dc51a1d5a57aef8e6774d1a9a78beb907caa6d8e2798c"
    sha256 big_sur:        "b0f468c3f75bb9c5fe67735e40d362916885b47ac678162b7a283a91813f8c25"
    sha256 catalina:       "d219d3bf36180ce31b3d7cf0352803a079ee058cecbba3aff6062ba793b01b1b"
    sha256 x86_64_linux:   "a94c3256cb943cb1638ae0c39e93c3bd5ac6106ebf148c1135325d1c95c3104f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DSPECIFY_RPATH=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.bash").write <<~EOS
      #!/bin/bash
      echo "Hello, world!"
    EOS
    system "#{bin}/kcov", testpath/"out", testpath/"hello.bash"
    assert_predicate testpath/"out/hello.bash/coverage.json", :exist?
  end
end

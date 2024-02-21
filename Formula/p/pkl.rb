class Pkl < Formula
  desc "Configuration-as-code language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.25.2.tar.gz"
  sha256 "810f6018562ec9b54a43ba3cea472a6d6242e15da15b73a94011e1f8abc34927"
  license "Apache-2.0"
  head "https://github.com/apple/pkl.git", branch: "main"

  depends_on "gpatch" => :build
  depends_on "openjdk" => :build

  def install
    system "patch", "-p1", "-i", "patches/graalVm23.patch"

    if OS.mac?
      build_os = "mac"
      bin_os = "macos"
    else
      build_os = "linux"
      bin_os = "linux"
    end
    if Hardware::CPU.intel?
      build_arch = "Amd64"
      bin_arch = "amd64"
    else
      build_arch = "Aarch64"
      bin_arch = "aarch64"
    end
    system "./gradlew", "--no-daemon", "pkl-cli:#{build_os}Executable#{build_arch}"
    bin.install "pkl-cli/build/executable/pkl-#{bin_os}-#{bin_arch}" => "pkl"
  end

  test do
    system "false"
  end
end

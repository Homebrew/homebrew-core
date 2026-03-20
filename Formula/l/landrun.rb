class Landrun < Formula
  desc "Lightweight, secure sandbox for running Linux processes using Landlock LSM"
  homepage "https://github.com/Zouuup/landrun"
  url "https://github.com/Zouuup/landrun/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "61bc92e1b808e1d4443b69a62498b74d5730a997703a70e6879486d95ea53aad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "bd1fe9ee50db6b17e5b6d698951ca85eeb7e635d7aaa9de60e3ca6bf03a5e051"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c390166baa601f71d8dc11c07ec0b3e1780ed5573b9fe35ebaed59046fcfc259"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/landrun"
  end

  test do
    lib_paths = %w[/lib /usr/lib /lib64 /usr/lib64].select { |dir| File.directory? dir }
    output = shell_output("#{bin}/landrun --rox /usr --ro #{lib_paths.join(",")} --best-effort -- pwd")
    assert_equal output.chomp, testpath.to_s
  end
end

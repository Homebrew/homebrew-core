class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.3.4.tar.gz"
  sha256 "ed99ee05c308095763b01adcbc4560c99576c7ed1af59b38a7786bb1469b3a90"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a42db7f64908f83de65a3d7baf4ab8f80584357a75d1884e37913eca755ae6aa"
    sha256 cellar: :any,                 arm64_ventura:  "0012f43ea8e8fb4cb5978be35889ab6b9a701883ac16a2f62a88fb27b182287c"
    sha256 cellar: :any,                 arm64_monterey: "f75d8d901cb23916e82be5f3e1747fa7c61c39da533123df29f8236300cd4d0d"
    sha256 cellar: :any,                 sonoma:         "2c9da96df700b8e6082bfb7ab34a308347de5b9d536a3b8f315c1085966ce424"
    sha256 cellar: :any,                 ventura:        "58bd84c9b8ffa9426f0e4561130abebfd560fca5c81445e3e4d15f2361287891"
    sha256 cellar: :any,                 monterey:       "62e31dbd0c5ff09406649aa9b824120166bb4a74ce3fa8ab76994db68ef05d4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f4dfdbbe43581cc086866f7b6bdc41cec9e1a1dbe7dfc1166652e73c2c3ed8b"
  end

  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    ENV["GEM_HOME"] = libexec
    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "deadfinder.gemspec"
    system "gem", "install", "deadfinder-#{version}.gem"
    bin.install libexec/"bin/deadfinder"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Avoid references to the Homebrew shims directory
    if OS.mac?
      shims_references = Dir[libexec/"extensions/**/ffi-*/mkmf.log"].select { |f| File.file? f }
      inreplace shims_references, Superenv.shims_path.to_s, "<**Reference to the Homebrew shims directory**>", false
    end
  end

  test do
    assert_match version.to_s, shell_output(bin/"deadfinder version")

    assert_match "Done", shell_output(bin/"deadfinder url https://brew.sh")
  end
end

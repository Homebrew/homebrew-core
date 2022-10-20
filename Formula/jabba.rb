class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.11.2.tar.gz"
  sha256 "33874c81387f03fe1a27c64cb6fb585a458c1a2c1548b4b86694da5f81164355"
  license "Apache-2.0"
  head "https://github.com/shyiko/jabba.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93e599fb7c61971f2d76c7c37254dfe5a407e604c3e64b27ba026e46124a8f96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72cd725e75b0d214c6cbc03bc87fcb15d9b824ea24eba43f267cdfc768edf460"
    sha256 cellar: :any_skip_relocation, monterey:       "8f142b8c305812437a8927250d4164b94015af9ed28282bc008e1d034a227000"
    sha256 cellar: :any_skip_relocation, big_sur:        "72c397a12fe10181efb7fca300d78d3244160c9a0a4dcbe2cd17c179df678db4"
    sha256 cellar: :any_skip_relocation, catalina:       "146e37a3138b919c497da279eecd2d282d5f6f5e0f1b9aa94257df2fbf19efba"
    sha256 cellar: :any_skip_relocation, mojave:         "6f2d27333e0b8d73ba2166c4abb960642d64a3efcd394ee5683e6c71b8d0c305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "359b80689e628a11217fe33067133d61eb52970610e45d54ace41705ccb06b5d"
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/shyiko/jabba"
    dir.install buildpath.children
    cd dir do
      ldflags = "-X main.version=#{version}"
      system "glide", "install"
      system "go", "build", "-ldflags", ldflags, "-o", bin/"jabba"
      prefix.install_metafiles
    end
  end

  test do
    jdk_version = "zulu@1.16.0-0"
    version_check ='openjdk version "16'

    ENV["JABBA_HOME"] = testpath/"jabba_home"

    system bin/"jabba", "install", jdk_version
    jdk_path = shell_output("#{bin}/jabba which #{jdk_version}").strip
    jdk_path += "/Contents/Home" if OS.mac?
    assert_match version_check,
                 shell_output("#{jdk_path}/bin/java -version 2>&1")
  end
end

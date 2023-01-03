class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  # fork blessed by previous maintener https://github.com/shyiko/jabba/issues/833#issuecomment-1338648294
  homepage "https://github.com/Jabba-Team/jabba"
  url "https://github.com/Jabba-Team/jabba/archive/0.12.0.tar.gz"
  sha256 "15a142239869733d7f0fe8c0cc0cd99f619e5bc8121ebabc9c28c382333b89c0"
  license "Apache-2.0"
  head "https://github.com/Jabba-Team/jabba.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f3bdbc2e3701682b298b0e838f5cfb784ad2b9ef50f00490a459e77a63eba71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93e599fb7c61971f2d76c7c37254dfe5a407e604c3e64b27ba026e46124a8f96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72cd725e75b0d214c6cbc03bc87fcb15d9b824ea24eba43f267cdfc768edf460"
    sha256 cellar: :any_skip_relocation, ventura:        "0d16e04cd31e6f9cd0b53744a1a79fe611ba20e10568edf833226b3888202baa"
    sha256 cellar: :any_skip_relocation, monterey:       "8f142b8c305812437a8927250d4164b94015af9ed28282bc008e1d034a227000"
    sha256 cellar: :any_skip_relocation, big_sur:        "72c397a12fe10181efb7fca300d78d3244160c9a0a4dcbe2cd17c179df678db4"
    sha256 cellar: :any_skip_relocation, catalina:       "146e37a3138b919c497da279eecd2d282d5f6f5e0f1b9aa94257df2fbf19efba"
    sha256 cellar: :any_skip_relocation, mojave:         "6f2d27333e0b8d73ba2166c4abb960642d64a3efcd394ee5683e6c71b8d0c305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "359b80689e628a11217fe33067133d61eb52970610e45d54ace41705ccb06b5d"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/Jabba-Team/jabba"
    dir.install buildpath.children
    cd dir do
      ldflags = "-X main.version=#{version}"
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    jdk_version = "zulu@17"
    version_check ='openjdk version "17'

    ENV["JABBA_HOME"] = testpath/"jabba_home"

    system bin/"jabba", "install", jdk_version
    jdk_path = shell_output("#{bin}/jabba which #{jdk_version}").strip
    jdk_path += "/Contents/Home" if OS.mac?
    assert_match version_check,
                 shell_output("#{jdk_path}/bin/java -version 2>&1")
  end
end

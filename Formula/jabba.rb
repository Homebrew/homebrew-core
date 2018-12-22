class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  homepage "https://github.com/shyiko/jabba"
  url "https://github.com/shyiko/jabba/archive/0.11.1.tar.gz"
  sha256 "dfdfeace9dfc0d6f6d7d719c76a3b8b6e90bcdbc9d7cec41856fac84395b5f94"
  head "https://github.com/shyiko/jabba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "86c773bc4a97e432bc6491087189918e5e1abde371e4339d2241f816ce833d55" => :mojave
    sha256 "cfd5d350cac91a435cb70921b5ebb69dd8705b40a48b195becea6035a6e110ed" => :high_sierra
    sha256 "8b5667589047a75e48b28b3d2721980294652e71bae47ccd5f4ec61ec62da8cb" => :sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
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
    ENV["JABBA_HOME"] = testpath/"jabba_home"
    system bin/"jabba", "install", "1.11.0"
    jdk_path = Utils.popen_read("#{bin}/jabba which 1.11.0").strip
    assert_match 'java version "11.0',
                 shell_output("#{jdk_path}/Contents/Home/bin/java -version 2>&1")
  end
end

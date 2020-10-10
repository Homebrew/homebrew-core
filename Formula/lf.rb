class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r17.tar.gz"
  sha256 "a6906f6c40de8cbd643d0dc6a7a25b83a6403f0e87a8352289189bea17123342"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1bb783c227f7c75a701d786fd0ffadd577ef09f4fe1aef0125e1f03a81ba106" => :catalina
    sha256 "92bbce3dd69010267a5ff66cd3472494ae9e11e7661fb0089bb44fb97fa24d77" => :mojave
    sha256 "05f7e48eccdff3dd0d2fb35ef82d7e9596e4a57b5b37c672e2f2e5a06af080fb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.gVersion=#{version}"
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end

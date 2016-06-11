class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      :tag => "v0.15.0",
      :revision => "6dc5d0f9c4cbc62828c91a923482c2341d36acb3"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "908c8d5416907d3480b2032d5e3d903ab317cbebf8c8db2dc2a49cf8022fcab5" => :el_capitan
    sha256 "cd12f55d981b6ed5e87e6b5495711cd091c29a72f925ddd9867c5856df4bd6ba" => :yosemite
    sha256 "ed9495536c866390692a5508a3b6c61f4da3b7501688258fbf3d644aa42bddfa" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    dir = buildpath/"src/github.com/hashicorp/consul-template"
    dir.install buildpath.children
    cd dir do
      system "make", "bootstrap"
      system "make", "updatedeps" if build.head?
      system "make", "dev"
      system "make", "test"
    end
    bin.install "bin/consul-template"
  end

  test do
    (testpath/"template").write <<-EOS.undent
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end

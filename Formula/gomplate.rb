class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v2.1.0.tar.gz"
  sha256 "812b8f25a905c157f48b38a841962724773e420a6691db5e974b2b6de0b4e3bb"
  head "https://github.com/hairyhenderson/gomplate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "747a86df327bf9cf9fa3efd8e2816aa691d59b9966e992a2e4c30860f0f630e0" => :high_sierra
    sha256 "7be6ee6cb94938fe60fd0729f0eff273221f3e77492eff0c338451d7df7ea85a" => :sierra
    sha256 "42511b540bfece02cc011606cf75883ae3c3891f2de9c4ebcf6a56f33492c4c3" => :el_capitan
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "upx" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    (buildpath/"src/github.com/hairyhenderson/gomplate").install buildpath.children
    cd "src/github.com/hairyhenderson/gomplate" do
      system "make", "compress", "VERSION=#{version}"
      bin.install "bin/gomplate-slim" => "gomplate"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/gomplate --version")
    assert_equal "gomplate version #{version}", output.chomp

    test_template = <<-TEMPLATE.unindent
      {{ range ("foo:bar:baz" | strings.SplitN ":" 2) }}{{.}}
      {{end}}
    TEMPLATE

    expected = <<-EXPECTED.unindent
      foo
      bar:baz
    EXPECTED

    assert_match expected, pipe_output("#{bin}/gomplate", test_template, 0)
  end
end

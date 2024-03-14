class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "93546e10971ca74c3192940fe9435b48368cefa677cef8a7532b214c6d8b6c39"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f302e5a73b4dc2193656ab5c7192c69583cca9f7ec33ea6e64b1d93afe047db7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ba93804868b13856e7be0179aaeec87b511d42e4c1add21d4f6e8ce65aa65be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83aa34cbd7c211d89f8efb4765d0f4279d24fbe18aed3a380e8ee0ca07ee0a07"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5a71876dedc77715472fbb6d8fa9b0ae341c446b6cca2d652b77864ae62f60d"
    sha256 cellar: :any_skip_relocation, ventura:        "7c27fa171b3eb561675c383448b991d1d3e02759fba76444c22a1d29cff74dac"
    sha256 cellar: :any_skip_relocation, monterey:       "70e5e1e43388d407f5beaa48265ea369c776df8457d06c9432876c1e0b768b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8bd7f1a1800998ddc710edf7e1a81393365c83dcee4abb92c60714719189d61"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/v2/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel --version")
  end
end

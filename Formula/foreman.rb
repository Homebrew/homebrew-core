class Foreman < Formula
  desc "Manage Procfile-based applications"
  homepage "https://ddollar.github.io/foreman/"
  url "https://github.com/ddollar/foreman.git",
      tag:      "v0.87.2",
      revision: "5b815c5d8077511664a712aca90b070229ca6413"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "70c762dd642d8f5aa3ca5a28e420b6c9f7befaf7699de073b7d62e174fdee88f" => :big_sur
    sha256 "575f9fbc16eca16cf479196ce44d87bb817ddb1e2eed59869ffe158d98d08a9f" => :arm64_big_sur
    sha256 "5c2b39c1f7e9667b9ebc6b7228b6cf31f06c2261c85019028272cfdda7073ea5" => :catalina
    sha256 "674b5fc005986f47294acedccba6b2a2bcdc1d423e392a356f8d58cc88a2c81a" => :mojave
    sha256 "b0d289ff31caf33f3d549af6dd615e37588aadb243355395380c4df5b0e52d63" => :high_sierra
  end

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    man1.install "man/foreman.1"
  end

  test do
    (testpath/"Procfile").write("test: echo 'test message'")
    expected_message = "test message"
    assert_match expected_message, shell_output("#{bin}/foreman start")
  end
end

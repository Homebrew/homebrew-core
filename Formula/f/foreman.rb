class Foreman < Formula
  desc "Manage Procfile-based applications"
  homepage "https://ddollar.github.io/foreman/"
  url "https://github.com/ddollar/foreman/archive/refs/tags/v0.90.0.tar.gz"
  sha256 "d9428f9ab4c2e2b4f9e22a35d19237f5ad6789e2e71110cfe26f8715f4e3a58a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "961597e37878c33f9903db7e51dc9be14d5fe11434e179527f9c25a045408d7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "961597e37878c33f9903db7e51dc9be14d5fe11434e179527f9c25a045408d7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "961597e37878c33f9903db7e51dc9be14d5fe11434e179527f9c25a045408d7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "961597e37878c33f9903db7e51dc9be14d5fe11434e179527f9c25a045408d7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "961597e37878c33f9903db7e51dc9be14d5fe11434e179527f9c25a045408d7c"
    sha256 cellar: :any_skip_relocation, ventura:       "961597e37878c33f9903db7e51dc9be14d5fe11434e179527f9c25a045408d7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23abef518736e00d017b564a9f78b2063a0fd93825d81bf79885ff6a909cf061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23abef518736e00d017b564a9f78b2063a0fd93825d81bf79885ff6a909cf061"
  end

  uses_from_macos "ruby"

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.4.0.gem"
    sha256 "8763e822ccb0f1d7bee88cde131b19a65606657b847cc7b7b4b82e772bcd8a3d"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

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

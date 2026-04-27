class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-19.0.0.tgz"
  sha256 "59f26fb4a2718283b0afe22a152f98d2ca7610f47748ac6384bc7348bcafb70c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b582625b17dfef6162b7d3512523947612759d9041fd674d1f9aec7edacd8437"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "526b50995578b849c4e07c5ae01b4d9e31009cae792bb522bb7daca5b701b250"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "526b50995578b849c4e07c5ae01b4d9e31009cae792bb522bb7daca5b701b250"
    sha256 cellar: :any_skip_relocation, sonoma:        "25c02f8b25c7a2612356eda14c810317c79eb04fe1d0fdde23001af8df8c6fee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b166c674b3724ca88eb232541651914e1a648e38e15e296bbedaaf2e09eae013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b166c674b3724ca88eb232541651914e1a648e38e15e296bbedaaf2e09eae013"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end

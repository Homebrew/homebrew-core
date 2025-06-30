class Gbox < Formula
  desc "Self-hostable sandbox for AI Agents to execute commands and surf web"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "802a2548ac97db2d1902142d93d1bebab73e1739bc9adf1351dda9a88e92e4e1"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "rsync" => :build
  depends_on "docker"
  depends_on "jq"
  depends_on "kind"
  depends_on "node"
  depends_on "yq"

  def install
    system "make", "brew-dist"
    prefix.install Dir["brew/*"]
    generate_completions_from_executable(bin/"gbox", "completion")
  end

  test do
    # Test gbox help
    output = shell_output("#{bin}/gbox --help")
    assert_match "Usage:", output

    # Test that the .env file was created and contains the correct hardcoded value.
    env_file = prefix/"manifests/docker/.env"
    assert_path_exists env_file
    assert_equal "PW_IMG_TAG=7614d46", env_file.read.strip

    # Test gbox profile management
    add_output = shell_output("#{bin}/gbox profile add -k xxx -n gbox-user -o local")
    assert_match "Profile added successfully", add_output

    current_output = shell_output("#{bin}/gbox profile current")
    assert_match "Profile Name: gbox-user", current_output
    assert_match "Organization Name: local", current_output
    assert_match "API Key: xxx", current_output
  end
end

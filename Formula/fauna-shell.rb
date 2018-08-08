require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.3.0.tgz"
  sha256 "e587255300cfd8e8be5afa5d9497bdb612eeeca5e165d65bd05fbd2e041ec840"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # just making sure the program was properly installed
    system bin/"fauna", "--help"

    require "open3"

    # there are no endpoints, so an error is raised
    _o, _e, s = Open3.capture3("#{bin}/fauna list-endpoints")
    assert_equal false, s.success?

    _o, _e, s = Open3.capture3("#{bin}/fauna add-endpoint https://endpoint1:8443", :stdin_data=>"secret\nendpoint1\n")
    assert s.success?

    # the endpoint 'endpoint1' was added and is listed as default (*)
    o, _e, s = Open3.capture3("#{bin}/fauna list-endpoints")
    assert_equal "endpoint1 *\n", o
    assert s.success?

    # by no providing an endpoint alias, it's taken from the hostname
    _o, _e, s = Open3.capture3("#{bin}/fauna add-endpoint https://endpoint2:8443", :stdin_data=>"secret\n\n")
    assert s.success?

    # the endpoint 'endpoint2' was added, and 'endpoint1' is still listed as default (*)
    o, _e, s = Open3.capture3("#{bin}/fauna list-endpoints")
    assert_equal "endpoint1 *\nendpoint2 \n", o
    assert s.success?

    # sets 'endpoint2' as the default endpoint
    _o, _e, s = Open3.capture3("#{bin}/fauna default-endpoint endpoint2")
    assert s.success?

    # endpoint 'endpoint2' is now the default endpoint (*)
    o, _e, s = Open3.capture3("#{bin}/fauna list-endpoints")
    assert_equal "endpoint1 \nendpoint2 *\n", o
    assert s.success?

    _o, _e, s = Open3.capture3("#{bin}/fauna delete-endpoint endpoint1", :stdin_data=>"y\n")
    assert s.success?

    o, _e, s = Open3.capture3("#{bin}/fauna list-endpoints")
    assert_equal "endpoint2 *\n", o
    assert s.success?

    _o, _e, s = Open3.capture3("#{bin}/fauna delete-endpoint endpoint2", :stdin_data=>"y\n")
    assert s.success?

    # there are no endpoints, so an error is raised
    _o, _e, s = Open3.capture3("#{bin}/fauna list-endpoints")
    assert_equal false, s.success?
  end
end

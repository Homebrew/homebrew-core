require "language/node"

class Inso < Formula
  desc "CLI for Insomnia"
  homepage "https://insomnia.rest"
  url "https://registry.npmjs.org/insomnia-inso/-/insomnia-inso-2.3.2.tgz"
  sha256 "3ae32671053f87957b508f40a2ffd5a610b03cae85ecffd801432c8288abcc03"
  license "MIT"

  depends_on "node"

  uses_from_macos "curl"

  def install
    # std_npm_install_args includes --build-from-source when brew itself is run
    # with the flag (as both CI does and formula developers are instructed to
    # do)
    #
    # in the case of the combination of uses_from_macos "curl", and
    # node-libcurl, that flags causes node-gyp to attempt to source Mac OS's
    # own libcurl.dylib, which fails as system dylibs are not made available in
    # such a way these days
    #
    # ignoring the --build-from-source flags below means that even in,
    # situations where brew requires that flag, it will be ignored for the npm
    # install command, and node will avoid attempting to source libcurl from
    # Mac OS's private dylibs
    npm_arguments = [
      "npm",
      "install",
      Language::Node.std_npm_install_args(libexec).delete_if do |arg|
        arg == "--build-from-source"
      end,
    ].flatten

    system(*npm_arguments)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    deuniversalize_machos
  end

  test do
    output = pipe_output("#{bin}/inso --help 2>&1")
    assert_match "Usage: inso", output
  end
end

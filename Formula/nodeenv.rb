class Nodeenv < Formula
  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://github.com/ekalinin/nodeenv/archive/1.5.0.tar.gz"
  sha256 "c79669818bf010d8539cc9a53729b6be089bb482daac15bca2bf4196b2343284"
  license "BSD-3-Clause"

  bottle :unneeded

  def install
    bin.install "nodeenv.py" => "nodeenv"
  end

  test do
    system bin/"nodeenv", "--node=0.10.40", "--prebuilt", "env-0.10.40-prebuilt"
    # Dropping into the virtualenv itself requires sourcing activate which
    # isn't easy to deal with. This ensures current Node installed & functional.
    ENV.prepend_path "PATH", testpath/"env-0.10.40-prebuilt/bin"

    (testpath/"test.js").write "console.log('hello');"
    assert_match "hello", shell_output("node test.js")
    assert_match "v0.10.40", shell_output("node -v")
  end
end

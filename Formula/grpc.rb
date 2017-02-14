class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "http://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.1.2.tar.gz"
  sha256 "373ef66b0919bedef70021ba6798eaefe1cb560a2c94ccd2631d38fc9268f524"
  head "https://github.com/grpc/grpc.git"

  bottle do
    root_url "http://storage.googleapis.com/grpc-public/bottles"
  end

  option "with-plugins", "Also install gRPC protoc plugins."

  depends_on "openssl"
  depends_on "pkg-config" => :run
  depends_on "protobuf"

  def install
    # Clone nanopb into third_party/nanopb IF THE DIRECTORY IS EMPTY.
    # gRPC v1.0 has nanopb as a submodule of grpc, which requires a clone
    # of nanopb into the directory. gRPC Master removed the submodule and
    # always have nanopb files in place, in which case a clone would give
    # error.
    # TODO(mxyan): find a better solution
    (bin+"grpc").write <<-EOS.undent
      #!/bin/sh
      [ "$(ls -A third_party/nanopb)" ] || git clone --branch=nanopb-0.3.5 https://github.com/nanopb/nanopb.git third_party/nanopb
    EOS

    system "make", "install", "prefix=#{prefix}"

    if build.with? "plugins"
      system "make", "install-plugins", "prefix=#{prefix}"

      # Link the Objective-C plugin to the name protoc expects.
      # TODO: Do this renaming on make install, for all languages.
      bin.install_symlink bin/"grpc_objective_c_plugin" => "protoc-gen-objcgrpc"
    end
  end

  test do
    system Formula["pkg-config"].bin/"pkg-config", "--libs", "grpc"
  end
end

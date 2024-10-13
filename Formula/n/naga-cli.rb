class NagaCli < Formula
  desc "Shader translation command-line tool"
  homepage "https://github.com/gfx-rs/naga"
  url "https://github.com/gfx-rs/naga/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "408128a255eba79763d9b7c5422d9c9d6a62019001f80f5ab28d34436c6189eb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/gfx-rs/naga.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c188ac74312bf3101d075a5246df61b578278f07762fb6e8493ad2b2624649af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42e71c4549c315dc91834ce7d227b9d9f0415be3597df973fa34704270ac6ab8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0001ad2fdf8d515a98cb9e6bbcdcb6fd758adc93a0a38e326b36a0c812e05d1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08a1b293aaf4ba443bb0659b02392025643e86f6411cf5dfd9f5271392341e06"
    sha256 cellar: :any_skip_relocation, sonoma:         "d79d01969fb1f617cd58a776b79a6861d7e9b85e5a0cccbee21b5062c269181e"
    sha256 cellar: :any_skip_relocation, ventura:        "afee30c8dbbdf7abceb6ecc479b65074747bbc15004a06059b9d421d503adfd3"
    sha256 cellar: :any_skip_relocation, monterey:       "edbddf341fd6349827649272141b8855daba030c4daf579f0007b9e59fae6b60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fb254beea5acaaccb1215137b30271235382aa388c4f2e1a4a73815d1af2039"
  end

  depends_on "rust" => :build

  conflicts_with "naga", because: "both install `naga` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    # sample taken from the Naga test suite
    test_wgsl = testpath/"test.wgsl"
    test_wgsl.write <<~EOF
      @fragment
      fn derivatives(@builtin(position) foo: vec4<f32>) -> @location(0) vec4<f32> {
          let x = dpdx(foo);
          let y = dpdy(foo);
          let z = fwidth(foo);
          return (x + y) * z;
      }
    EOF
    assert_equal "Validation successful", shell_output("#{bin/"naga"} #{test_wgsl}").strip
    test_out_wgsl = testpath/"test_out.wgsl"
    test_out_frag = testpath/"test_out.frag"
    test_out_metal = testpath/"test_out.metal"
    test_out_hlsl = testpath/"test_out.hlsl"
    test_out_dot = testpath/"test_out.dot"
    system bin/"naga", test_wgsl, test_out_wgsl, test_out_frag, test_out_metal, test_out_hlsl, test_out_dot,
           "--profile", "es310", "--entry-point", "derivatives"
    assert_equal test_out_wgsl.read, <<~EOF
      @fragment#{" "}
      fn derivatives(@builtin(position) foo: vec4<f32>) -> @location(0) vec4<f32> {
          let x = dpdx(foo);
          let y = dpdy(foo);
          let z = fwidth(foo);
          return ((x + y) * z);
      }
    EOF
    assert_equal test_out_frag.read, <<~EOF
      #version 310 es

      precision highp float;
      precision highp int;

      layout(location = 0) out vec4 _fs2p_location0;

      void main() {
          vec4 foo = gl_FragCoord;
          vec4 x = dFdx(foo);
          vec4 y = dFdy(foo);
          vec4 z = fwidth(foo);
          _fs2p_location0 = ((x + y) * z);
          return;
      }

    EOF
    assert_equal test_out_metal.read, <<~EOF
      // language: metal1.0
      #include <metal_stdlib>
      #include <simd/simd.h>

      using metal::uint;


      struct derivativesInput {
      };
      struct derivativesOutput {
          metal::float4 member [[color(0)]];
      };
      fragment derivativesOutput derivatives(
        metal::float4 foo [[position]]
      ) {
          metal::float4 x = metal::dfdx(foo);
          metal::float4 y = metal::dfdy(foo);
          metal::float4 z = metal::fwidth(foo);
          return derivativesOutput { (x + y) * z };
      }
    EOF
    assert_equal test_out_hlsl.read, <<~EOF
      struct FragmentInput_derivatives {
          float4 foo_1 : SV_Position;
      };

      float4 derivatives(FragmentInput_derivatives fragmentinput_derivatives) : SV_Target0
      {
          float4 foo = fragmentinput_derivatives.foo_1;
          float4 x = ddx(foo);
          float4 y = ddy(foo);
          float4 z = fwidth(foo);
          return ((x + y) * z);
      }
    EOF
    assert_equal test_out_dot.read, <<~EOF
      digraph Module {
      	subgraph cluster_globals {
      		label="Globals"
      	}
      	subgraph cluster_ep0 {
      		label="Fragment/'derivatives'"
      		node [ style=filled ]
      		ep0_e0 [ color="#8dd3c7" label="[1] Argument[0]" ]
      		ep0_e1 [ color="#fccde5" label="[2] dXNone" ]
      		ep0_e0 -> ep0_e1 [ label="" ]
      		ep0_e2 [ color="#fccde5" label="[3] dYNone" ]
      		ep0_e0 -> ep0_e2 [ label="" ]
      		ep0_e3 [ color="#fccde5" label="[4] dWidthNone" ]
      		ep0_e0 -> ep0_e3 [ label="" ]
      		ep0_e4 [ color="#fdb462" label="[5] Add" ]
      		ep0_e2 -> ep0_e4 [ label="right" ]
      		ep0_e1 -> ep0_e4 [ label="left" ]
      		ep0_e5 [ color="#fdb462" label="[6] Multiply" ]
      		ep0_e3 -> ep0_e5 [ label="right" ]
      		ep0_e4 -> ep0_e5 [ label="left" ]
      		ep0_s0 [ shape=square label="Root" ]
      		ep0_s1 [ shape=square label="Emit" ]
      		ep0_s2 [ shape=square label="Emit" ]
      		ep0_s3 [ shape=square label="Emit" ]
      		ep0_s4 [ shape=square label="Emit" ]
      		ep0_s5 [ shape=square label="Return" ]
      		ep0_s0 -> ep0_s1 [ arrowhead=tee label="" ]
      		ep0_s1 -> ep0_s2 [ arrowhead=tee label="" ]
      		ep0_s2 -> ep0_s3 [ arrowhead=tee label="" ]
      		ep0_s3 -> ep0_s4 [ arrowhead=tee label="" ]
      		ep0_s4 -> ep0_s5 [ arrowhead=tee label="" ]
      		ep0_e5 -> ep0_s5 [ label="value" ]
      		ep0_s1 -> ep0_e1 [ style=dotted ]
      		ep0_s2 -> ep0_e2 [ style=dotted ]
      		ep0_s3 -> ep0_e3 [ style=dotted ]
      		ep0_s4 -> ep0_e4 [ style=dotted ]
      		ep0_s4 -> ep0_e5 [ style=dotted ]
      	}
      }
    EOF
  end
end

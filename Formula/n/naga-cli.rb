class NagaCli < Formula
  desc "Shader translation command-line tool"
  homepage "https://wgpu.rs/"
  url "https://static.crates.io/crates/naga-cli/naga-cli-25.0.0.crate"
  sha256 "ede66d4c10828909e20b14811b0e70b1d4ae8ff03945e0ec91eb4d75842a2309"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/gfx-rs/wgpu.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f381df3f1f5551ef09d6f5a1db7c785ec7e1988cda561a593f94a32225c8993"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d457e86412f3df14521e8267d1ae644d399252c77fcf9bfa9384240307221465"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9280d8353ef24bb2e18d9e51ebb092169f6d7320f5206abe2c7b5640c4ed54d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc3ea3f9e021d67d263779865162628850433346461726780d2c1236cdc80c74"
    sha256 cellar: :any_skip_relocation, ventura:       "baa2ba2e910a5516ee2ad96fd0688287eb9c4995bf72c057ffaf573bee22e336"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1299f4b9af4abfe2831665c53af2223929f4b0dfd6f1ec6bf534bfee77b7a075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00a19e82f71008d5e690cb4c72fcc9ecc7c86c9a3d0626fab0918d12bf25ecd7"
  end

  depends_on "rust" => :build

  conflicts_with "naga", because: "both install `naga` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # sample taken from the Naga test suite
    test_wgsl = testpath/"test.wgsl"
    test_wgsl.write <<~WGSL
      @fragment
      fn derivatives(@builtin(position) foo: vec4<f32>) -> @location(0) vec4<f32> {
          let x = dpdx(foo);
          let y = dpdy(foo);
          let z = fwidth(foo);
          return (x + y) * z;
      }
    WGSL
    assert_equal "Validation successful", shell_output("#{bin}/naga #{test_wgsl}").strip
    test_out_wgsl = testpath/"test_out.wgsl"
    test_out_frag = testpath/"test_out.frag"
    test_out_metal = testpath/"test_out.metal"
    test_out_hlsl = testpath/"test_out.hlsl"
    test_out_dot = testpath/"test_out.dot"
    system bin/"naga", test_wgsl, test_out_wgsl, test_out_frag, test_out_metal, test_out_hlsl, test_out_dot,
           "--profile", "es310", "--entry-point", "derivatives"
    assert_equal <<~WGSL, test_out_wgsl.read
      @fragment#{" "}
      fn derivatives(@builtin(position) foo: vec4<f32>) -> @location(0) vec4<f32> {
          let x = dpdx(foo);
          let y = dpdy(foo);
          let z = fwidth(foo);
          return ((x + y) * z);
      }
    WGSL
    assert_equal <<~GLSL, test_out_frag.read
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

    GLSL
    assert_equal <<~CPP, test_out_metal.read
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
    CPP
    assert_equal <<~HLSL, test_out_hlsl.read
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
    HLSL
    assert_equal <<~DOT, test_out_dot.read
      digraph Module {
      	subgraph cluster_globals {
      		label="Globals"
      	}
      	subgraph cluster_ep0 {
      		label="Fragment/'derivatives'"
      		node [ style=filled ]
      		ep0_e0 [ color="#8dd3c7" label="[0] Argument[0]" ]
      		ep0_e1 [ color="#fccde5" label="[1] dXNone" ]
      		ep0_e0 -> ep0_e1 [ label="" ]
      		ep0_e2 [ color="#fccde5" label="[2] dYNone" ]
      		ep0_e0 -> ep0_e2 [ label="" ]
      		ep0_e3 [ color="#fccde5" label="[3] dWidthNone" ]
      		ep0_e0 -> ep0_e3 [ label="" ]
      		ep0_e4 [ color="#fdb462" label="[4] Add" ]
      		ep0_e2 -> ep0_e4 [ label="right" ]
      		ep0_e1 -> ep0_e4 [ label="left" ]
      		ep0_e5 [ color="#fdb462" label="[5] Multiply" ]
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
    DOT
  end
end
